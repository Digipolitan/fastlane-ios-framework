module Fastlane
  module Actions
    module SharedValues
    end

    class PodspecInitAction < Action
      def self.run(params)
        podspec = params[:podspec]
        if podspec == nil
          if (xcodeproj = Dir["*.xcodeproj"]) != nil && xcodeproj.length > 0
            podspec = File.basename(xcodeproj.first, ".xcodeproj")
          end
          if podspec == nil
            UI.user_error! "Podspec cannot be found"
          else
            podspec = "#{podspec}.podspec"
          end
        end
        data = "Pod::Spec.new do |s|\n";
        data += "s.name = \"#{params[:pod_name]}\"\n"
        data += "s.version = \"#{params[:version]}\"\n"
        if summary = params[:summary]
          data += "s.summary = \"#{summary}\"\n"
        end
        if homepage = params[:homepage]
          data += "s.homepage = \"#{homepage}\"\n"
        end
        if authors = params[:authors]
          authors_field = ""
          i = 0
          while i < authors.length do
            if i > 0
              authors_field += ", "
            end
            authors_field += authors[i]
            i += 1
          end
          if i > 0
            data += "s.authors = \"#{authors_field}\"\n"
          end
        end
        data += "s.source = { :git => \"#{params[:git_url]}\", :tag => \"#{params[:tag_prefix]}\#{s.version}\" }\n"
        data += "s.license = { :type => \"#{params[:license]}\", :file => \"LICENSE\" }\n"
        data += "s.source_files = 'Sources/**/*.{swift,h}'\n"
        if ios = params[:ios_deployment_target]
          data += "s.ios.deployment_target = '#{ios}'\n"
        end
        if watchos = params[:watchos_deployment_target]
          data += "s.watchos.deployment_target = '#{watchos}'\n"
        end
        if tvos = params[:tvos_deployment_target]
          data += "s.tvos.deployment_target = '#{tvos}'\n"
        end
        if osx = params[:osx_deployment_target]
          data += "s.osx.deployment_target = '#{osx}'\n"
        end
        data += "s.requires_arc = true\n"
        data += "end"
        File.open(podspec, "w") { |file|
          file.puts(data)
        }
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Init a podspec with your configuration"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :podspec,
                                       env_name: "PODSPEC",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :pod_name,
                                       env_name: "POD_NAME"),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "PODSPEC_VERSION"),
          FastlaneCore::ConfigItem.new(key: :summary,
                                       env_name: "POD_SUMMARY",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :authors,
                                       env_name: "POD_AUTHORS",
                                       optional: true,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :homepage,
                                       env_name: "POD_HOMEPAGE",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :git_url,
                                       env_name: "POD_GIT_URL"),
          FastlaneCore::ConfigItem.new(key: :tag_prefix,
                                      env_name: "POD_TAG_PREFIX",
                                      default_value: "v"),
          FastlaneCore::ConfigItem.new(key: :license,
                                       env_name: "POD_LICENSE",
                                       default_value: "BSD"),
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
