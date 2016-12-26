module Fastlane
  module Actions
    module SharedValues
    end

    class PodfileInitAction < Action
      def self.run(params)
        xcodeproj = params[:xcodeproj]
        project_name = File.basename(xcodeproj, ".xcodeproj")
        podfile_path = File.join(File.dirname(xcodeproj), "Podfile")
        platforms = {}
        if ios_deployment_target = params[:ios_deployment_target]
          platforms["iOS"] = ios_deployment_target
        end
        if watchos_deployment_target = params[:watchos_deployment_target]
          platforms["watchOS"] = watchos_deployment_target
        end
        if tvos_deployment_target = params[:tvos_deployment_target]
          platforms["tvOS"] = tvos_deployment_target
        end
        if osx_deployment_target = params[:osx_deployment_target]
          platforms["OSX"] = osx_deployment_target
        end
        data = []
        data.push("workspace '#{project_name}.xcworkspace'\n")
        data.push(self.create_target_group(project_name, platforms, "Framework targets"))
        data.push(self.create_target_group("#{project_name}Tests", platforms, "Tests targets"))
        data.push(self.create_target_group("#{project_name}Sample", platforms, "Samples targets", "Samples"))
        File.open(podfile_path, "w") { |file|
          file.puts(data.join("\n"))
        }
      end

      def self.create_target_group(name, platforms, comments = nil, project_path = nil)
        data = ""
        if comments != nil
          data += "## #{comments}\n"
        end
        data += "abstract_target \"#{name}\" do\n"
        data += "\tuse_frameworks!\n\n"
        targets = []
        platforms.each { |platform, min_deployment|
          project = nil
          if project_path != nil
            project = File.join(project_path, "#{name}-#{platform}", "#{name}-#{platform}")
          end
          targets.push(self.create_target(name, platform, min_deployment, project))
        }
        data += targets.join("\n")
        data += "end\n"
        return data
      end

      def self.create_target(project_name, platform, min_deployment, project = nil)
        data = "\ttarget '#{project_name}-#{platform}' do\n"
        if project != nil
          data += "\t\tproject '#{project}'\n"
        end
        data += "\t\tplatform :#{platform.downcase}, '#{min_deployment}'\n"
        data += "\tend\n"
        return data
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Init a Podfile with your configuration"
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
