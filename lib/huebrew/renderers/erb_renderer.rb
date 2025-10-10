# frozen_string_literal: true

require "erb"

module Huebrew
  module Renderers
    # ERB template renderer
    class ErbRenderer
      # Render a template with context
      # @param template_path [String] Path to ERB template
      # @param context [Hash] Variables to pass to template
      # @return [String] Rendered output
      def self.render(template_path, context = {})
        unless File.exist?(template_path)
          raise NotFoundError, "Template not found: #{template_path}"
        end

        template_content = File.read(template_path)
        erb = ERB.new(template_content, trim_mode: "-")

        # Create a binding with the context variables
        binding_context = BindingContext.new(context)
        erb.result(binding_context.get_binding)
      end

      # Find template in search paths
      # @param name [String] Template name (without .erb extension)
      # @return [String, nil] Template path or nil if not found
      def self.find_template(name)
        template_name = "#{name}.erb"

        # Search in user templates
        user_template = File.join(Dir.home, ".huebrew", "templates", template_name)
        return user_template if File.exist?(user_template)

        # Search in gem templates
        gem_template = File.expand_path("../../../templates/#{template_name}", __dir__)
        return gem_template if File.exist?(gem_template)

        nil
      end

      # Binding context for ERB
      class BindingContext
        def initialize(context = {})
          context.each do |key, value|
            instance_variable_set("@#{key}", value)

            # Create accessor methods
            define_singleton_method(key) { instance_variable_get("@#{key}") }
          end
        end

        def get_binding
          binding
        end
      end
    end
  end
end
