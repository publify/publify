$("#feedback_<%= raw (@feedback.id) %>").html('<%= raw escape_javascript(render(partial: "spam", locals: { comment: @feedback })) %>');
