module Fastlane
  module Actions
    module SharedValues
    end

    class EditPodfileAction < Action
      def self.run(params)
        xcodeproj = params[:xcodeproj]
        project_name = File.basename(xcodeproj, ".xcodeproj")
        test_project_name = "#{project_name}Tests"
        podfile_path = File.join(File.dirname(xcodeproj), "Podfile")
        data = []
        if ios_deployment_target = params[:ios_deployment_target]
          data.push(create_target(project_name, "iOS", ios_deployment_target))
          data.push(create_target(test_project_name, "iOS", ios_deployment_target))
        end
        if watchos_deployment_target = params[:watchos_deployment_target]
          data.push(create_target(project_name, "watchOS", watchos_deployment_target))
        end
        if tvos_deployment_target = params[:tvos_deployment_target]
          data.push(create_target(project_name, "tvOS", tvos_deployment_target))
          data.push(create_target(test_project_name, "tvOS", tvos_deployment_target))
        end
        if osx_deployment_target = params[:osx_deployment_target]
          data.push(create_target(project_name, "OSX", osx_deployment_target))
          data.push(create_target(test_project_name, "OSX", osx_deployment_target))
        end
        File.open(podfile_path, "w") { |file|
          file.puts(data.join("\n"))
        }
      end

      def self.create_target(project_name, platform, min_deployment)
        data = "target '#{project_name}-#{platform}' do\n"
        data += "\tuse_frameworks!\n"
        data += "\tplatform :#{platform.downcase}, '#{min_deployment}'\n"
        data += "end\n"
        return data
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Edit the generated Podfile with your configuration"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                       env_name: "XCODEPROJ",
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please pass the path to the project, not the workspace") if value.end_with? ".xcworkspace"
                                         UI.user_error!("Could not find Xcode project") if !File.exist?(value) and !Helper.is_test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :ios_deployment_target,
                                       env_name: "POD_IOS_DEPLOYMENT_TARGET",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :osx_deployment_target,
                                       env_name: "POD_OSX_DEPLOYMENT_TARGET",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :tvos_deployment_target,
                                       env_name: "POD_TVOS_DEPLOYMENT_TARGET",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :watchos_deployment_target,
                                       env_name: "POD_WATCHOS_DEPLOYMENT_TARGET",
                                       optional: true)
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
