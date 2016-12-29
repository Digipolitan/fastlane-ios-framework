module Fastlane
  module Actions
    module SharedValues
    end

    class PodspecLintAction < Action
      def self.run(params)
        cmd = ["pod spec lint"]
        if podspec_path = params[:path]
          cmd << podspec_path
        end

        if params[:allow_warnings]
          cmd << "--allow-warnings"
        end

        if params[:use_libraries]
          cmd << "--use-libraries"
        end

        if params[:verbose]
          cmd << "--verbose"
        end

        Actions.sh(cmd.join(" "))
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Validate a Podspec"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "The Podspec you want to lint",
                                       env_name: "PODSPEC_PATH",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("File must be a `.podspec` or `.podspec.json`") unless value.end_with?(".podspec", ".podspec.json")
                                       end),
          FastlaneCore::ConfigItem.new(key: :allow_warnings,
                                       description: "Allow warnings during pod lint",
                                       optional: true,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :use_libraries,
                                       description: "Allow lint to use static libraries to install the spec",
                                       optional: true,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       description: "Show more debugging information",
                                       is_string: false,
                                       default_value: false)
        ]
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.category
        :misc
      end
    end
  end
end
