module ContentState
  class Factory
    def self.derived_from(content)
      state = [New, Draft, PublicationPending,
               JustPublished, Published].detect(self) do |k|
        k.derivable_from(content)
      end.instance

      unless state
        raise "No derivable state for #{content.inspect}"
      else
        return state
      end
    end
  end
end
