module Fastlane
  module Actions
    module SharedValues
    end

    class PodfileInitAction < Action
      def self.run(params)
        xcodeproj = params[:xcodeproj]
        project_name = File.basename(xcodeproj, ".xcodeproj")
        podfile_path = File.join(File.dirname(xcodeproj), "Podfile")
        frameworks_target = self.create_target("Frameworks", true, nil, nil, "Frameworks targets")
        tests_target = self.create_target("Tests", true, nil, nil, "Tests targets")
        samples_target = self.create_target("Samples", true, nil, nil, "Samples targets")
        if ios_deployment_target = params[:ios_deployment_target]
          self.link_platform(project_name, {
            name: "iOS",
            version: ios_deployment_target
            }, frameworks_target, tests_target, samples_target)
        end
        if watchos_deployment_target = params[:watchos_deployment_target]
          platform = {
            name: "watchOS",
            version: watchos_deployment_target
          }
          self.link_platform(project_name, platform, frameworks_target)
          sample_name = "#{project_name}Sample-#{platform[:name]}"
          watch_wrapper = self.create_target("watchOS", false, nil, File.join("Samples", sample_name, sample_name))
          self.link_target(samples_target, watch_wrapper)
          self.link_target(watch_wrapper, self.create_target(sample_name, false, {
            name: 'iOS',
            version: '8.0'
            }))
          self.link_target(watch_wrapper, self.create_target("#{sample_name} WatchKit Extension", false, platform))
        end
        if tvos_deployment_target = params[:tvos_deployment_target]
          self.link_platform(project_name, {
            name: "tvOS",
            version: tvos_deployment_target
            }, frameworks_target, tests_target, samples_target)
        end
        if osx_deployment_target = params[:osx_deployment_target]
          self.link_platform(project_name, {
            name: "OSX",
            version: osx_deployment_target
            }, frameworks_target, tests_target, samples_target)
        end
        data = []
        data.push("workspace '#{project_name}.xcworkspace'\n")
        data.push(self.target_to_s(frameworks_target))
        data.push(self.target_to_s(tests_target))
        data.push(self.target_to_s(samples_target))
        File.open(podfile_path, "w") { |file|
           file.puts(data.join("\n"))
        }
      end

      def self.target_to_s(target, depth = 0)
        tab = "\t" * depth
        child_depth = depth + 1
        child_tab = "\t" * child_depth
        keyword = target[:targets] != nil ? "abstract_target" : "target"
        data = ""
        if comments = target[:comments]
          data = "#{tab}## #{comments}\n"
        end
        data += "#{tab}#{keyword} '#{target[:name]}' do\n"
        if project = target[:project]
          data += "#{child_tab}project '#{project}'\n"
        end
        if target[:use_frameworks]
          data += "#{child_tab}use_frameworks!\n"
        end
        if platform_name = target[:platform] and min_deployment = target[:min_deployment]
          data += "#{child_tab}platform :#{platform_name.downcase}, '#{min_deployment}'\n"
        end
        if child_targets = target[:targets]
          builder = []
          child_targets.each { |child_target|
            builder.push(self.target_to_s(child_target, child_depth))
          }
          data += builder.join("\n")
        end
        data += "#{tab}end\n"
        return data
      end

      def self.link_platform(project_name, platform, frameworks_target, tests_target = nil, samples_target = nil)
        platform_name = platform[:name]
        self.link_target(frameworks_target, self.create_target("#{project_name}-#{platform_name}", false, platform))
        if tests_target != nil
          self.link_target(tests_target, self.create_target("#{project_name}Tests-#{platform_name}", false, platform))
        end
        if samples_target != nil
          sample_name = "#{project_name}Sample-#{platform_name}"
          self.link_target(samples_target, self.create_target(sample_name, false, platform, File.join("Samples", sample_name, sample_name)))
        end
      end

      def self.create_target(name, use_frameworks = true, platform = nil, project = nil, comments = nil)
        target = {
          name: name
        }
        if use_frameworks == true
          target[:use_frameworks] = use_frameworks
        end
        if platform != nil
          target[:platform] = platform[:name]
          target[:min_deployment] = platform[:version]
        end
        if project != nil
          target[:project] = project
        end
        if comments != nil
          target[:comments] = comments
        end
        return target
      end

      def self.link_target(parent_target, child_target)
        if parent_target[:targets] == nil
          parent_target[:targets] = []
        end
        parent_target[:targets].push(child_target)
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
