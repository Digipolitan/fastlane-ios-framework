module Fastlane
  module Actions
    module SharedValues
    end

    class PodspecInitAction < Action
      def self.run(params)
        podspec_path = params[:path]
        if podspec_path == nil
          if (podspec = Dir["*.podspec"]) != nil && podspec.length > 0
            podspec_path = podspec.first
          else
            UI.user_error! "The Podspec file cannot be found"
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
          if authors.length > 0
            authors_field = authors.join(", ")
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
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "The podspec path",
                                       env_name: "PODSPEC_PATH",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :pod_name,
                                       description: "The name of the framework of CocoaPods",
                                       env_name: "POD_NAME"),
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "The framework version",
                                       env_name: "PODSPEC_VERSION"),
          FastlaneCore::ConfigItem.new(key: :summary,
                                       description: "Short description on CocoaPods",
                                       env_name: "POD_SUMMARY",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :authors,
                                       description: "Array of authors",
                                       env_name: "POD_AUTHORS",
                                       optional: true,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :homepage,
                                       description: "The homepage description of your framework",
                                       env_name: "POD_HOMEPAGE",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :git_url,
                                       description: "The source git URL of the framework",
                                       env_name: "POD_GIT_URL"),
          FastlaneCore::ConfigItem.new(key: :tag_prefix,
                                       description: "The tag prefix for versioning",
                                       env_name: "POD_TAG_PREFIX",
                                       default_value: "v"),
          FastlaneCore::ConfigItem.new(key: :license,
                                       description: "License type",
                                       env_name: "POD_LICENSE",
                                       default_value: "BSD"),
          FastlaneCore::ConfigItem.new(key: :ios_deployment_target,
                                       description: "Minimum iOS deployment target",
                                       env_name: "POD_IOS_DEPLOYMENT_TARGET",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :osx_deployment_target,
                                       description: "Minimum OSX deployment target",
                                       env_name: "POD_OSX_DEPLOYMENT_TARGET",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :tvos_deployment_target,
                                       description: "Minimum tvOS deployment target",
                                       env_name: "POD_TVOS_DEPLOYMENT_TARGET",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :watchos_deployment_target,
                                       description: "Minimum watchOS deployment target",
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

      def self.category
        :misc
      end
    end
  end
end
