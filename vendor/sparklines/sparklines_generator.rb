class SparklinesGenerator < Rails::Generator::Base
	def manifest
		record do |m|
			# Model class, unit test, and fixtures.
			m.template 'sparklines_controller.rb',      File.join('app/controllers', "sparklines_controller.rb")
			m.template 'sparklines_helper.rb',  File.join('app/helpers', "sparklines_helper.rb")
		end
	end
end
