module Fastlane
  module Actions
    module SharedValues
    end

    class EditXcodeprojAction < Action
      def self.run(params)
        xcodeproj = params[:xcodeproj]
        project_name = File.basename(xcodeproj, ".xcodeproj")
        schemes = Dir[File.join(xcodeproj, 'xcshareddata', 'xcschemes', '*.xcscheme')]
        project = Xcodeproj::Project.open(xcodeproj)
        all_targets_map = Hash[project.targets.map { |key| [key.name, key] }]
        all_schemes_map = Hash[schemes.map { |key| [File.basename(key, ".xcscheme"), key] }]
        if params[:ios] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "iOS")
        end
        if params[:watchos] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "watchOS")
        end
        if params[:tvos] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "tvOS")
        end
        if params[:osx] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "OSX")
        end
        project.save()
      end

      def self.remove_platform(all_targets_map, all_schemes_map, project_name, platform)
        if target = all_targets_map["#{project_name}Tests-#{platform}"]
          target.remove_from_project()
        end
        if target = all_targets_map["#{project_name}-#{platform}"]
          target.remove_from_project()
        end
        if scheme = all_schemes_map["#{project_name}-#{platform}"]
          File.delete(scheme)
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Edit the generated Xcode project with your configuration"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                       env_name: "XCODEPROJ",
                                       optional: false,
                                       verify_block: proc do |value|
                                       end),
          FastlaneCore::ConfigItem.new(key: :ios,
                                       env_name: "EDIT_XCODEPROJ_IOS",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :watchos,
                                       env_name: "EDIT_XCODEPROJ_WATCHOS",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :tvos,
                                      env_name: "EDIT_XCODEPROJ_TVOS",
                                      is_string: false,
                                      default_value: true),
          FastlaneCore::ConfigItem.new(key: :osx,
                                       env_name: "EDIT_XCODEPROJ_OSX",
                                       is_string: false,
                                       default_value: true)
        ]
      end

      def self.authors
        ["bbriatte", "vbalasubramaniam"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
