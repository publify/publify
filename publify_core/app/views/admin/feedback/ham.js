$("#feedback_<%= raw(@feedback.id) %>").html('<%= raw escape_javascript(render(partial: "ham", locals: { comment: @feedback })) %>');
