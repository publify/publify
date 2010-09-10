module UploadProgress #:nodoc:
  # Upload Progress abstracts the progress of an upload.  It's used by the
  # multipart progress IO that keeps track of the upload progress and creating
  # the application depends on.  It contians methods to update the progress
  # during an upload and read the statistics such as +received_bytes+,
  # +total_bytes+, +completed_percent+, +bitrate+, and
  # +remaining_seconds+
  #
  # You can get the current +Progress+ object by calling +upload_progress+ instance
  # method in your controller or view.
  #
  class Progress
    unless const_defined? :MIN_SAMPLE_TIME
      # Number of seconds between bitrate samples.  Updates that occur more
      # frequently than +MIN_SAMPLE_TIME+ will not be queued until this
      # time passes.  This behavior gives a good balance of accuracy and load
      # for both fast and slow transfers.
      MIN_SAMPLE_TIME = 0.150

      # Number of seconds between updates before giving up to try and calculate
      # bitrate anymore
      MIN_STALL_TIME = 10.0

      # Number of samples used to calculate bitrate
      MAX_SAMPLES = 20
    end

    # Number bytes received from the multipart post
    attr_reader :received_bytes

    # Total number of bytes expected from the mutlipart post
    attr_reader :total_bytes

    # The last time the upload history was updated
    attr_reader :last_update_time

    # A message you can set from your controller or view to be rendered in the
    # +upload_status_text+ helper method.  If you set a messagein a controller
    # then call <code>session.update</code> to make that message available to
    # your +upload_status+ action.
    attr_accessor :message

    # Create a new Progress object passing the expected number of bytes to receive
    def initialize(total)
      @total_bytes = total
      reset!
    end

    # Resets the received_bytes, last_update_time, message and bitrate, but
    # but maintains the total expected bytes
    def reset!
      @received_bytes, @last_update_time, @stalled, @message = 0, 0, false, ''
      reset_history
    end

    # Number of bytes left for this upload
    def remaining_bytes
      @total_bytes - @received_bytes
    end

    # Completed percent in integer form from 0..100
    def completed_percent
      (@received_bytes * 100 / @total_bytes).to_i rescue 0
    end

    # Updates this UploadProgress object with the number of bytes received
    # since last update time and the absolute number of seconds since the
    # beginning of the upload.
    #
    # This method is used by the +MultipartProgress+ module and should
    # not be called directly.
    def update!(bytes, elapsed_seconds)#:nodoc:
      if @received_bytes + bytes > @total_bytes
        #warn "Progress#update received bytes exceeds expected bytes"
        bytes = @total_bytes - @received_bytes
      end

      @received_bytes += bytes

      # Age is the duration of time since the last update to the history
      age = elapsed_seconds - @last_update_time

      # Record the bytes received in the first element of the history
      # in case the sample rate is exceeded and we shouldn't record at this
      # time
      @history.first[0] += bytes
      @history.first[1] += age

      history_age = @history.first[1]

      @history.pop while @history.size > MAX_SAMPLES
      @history.unshift([0,0]) if history_age > MIN_SAMPLE_TIME

      if history_age > MIN_STALL_TIME
        @stalled = true
        reset_history
      else
        @stalled = false
      end

      @last_update_time = elapsed_seconds

      self
    end

    # Calculates the bitrate in bytes/second. If the transfer is stalled or
    # just started, the bitrate will be 0
    def bitrate
      history_bytes, history_time = @history.transpose.map { |vals| vals.inject { |sum, v| sum + v } }
      history_bytes / history_time rescue 0
    end

    # Number of seconds elapsed since the start of the upload
    def elapsed_seconds
      @last_update_time
    end

    # Calculate the seconds remaining based on the current bitrate. Returns
    # O seconds if stalled or if no bytes have been received
    def remaining_seconds
      remaining_bytes / bitrate rescue 0
    end

    # Returns true if there are bytes pending otherwise returns false
    def finished?
      remaining_bytes <= 0
    end

    # Returns true if some bytes have been received
    def started?
      @received_bytes > 0
    end

    # Returns true if there has been a delay in receiving bytes.  The delay
    # is set by the constant MIN_STALL_TIME
    def stalled?
      @stalled
    end

    private
    def reset_history
      @history = [[0,0]]
    end
  end
end
