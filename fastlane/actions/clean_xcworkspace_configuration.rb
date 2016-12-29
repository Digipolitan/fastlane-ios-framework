module Fastlane
  module Actions
    module SharedValues
    end

    class CleanXcworkspaceConfigurationAction < Action
      def self.run(params)
        xcworkspace = params[:xcworkspace]
        if xcworkspace == nil
          if (files = Dir["*.xcworkspace"]) != nil && files.length > 0
            xcworkspace = files.first
          end
          if xcworkspace == nil
            UI.user_error! "xcworkspace cannot be found"
          end
        end
        workspace = Xcodeproj::Workspace.new_from_xcworkspace(xcworkspace)
        all_xcodeprojs_map = Hash[workspace.file_references.map { |key| [File.basename(key.path, ".xcodeproj"), key] }]
        project_name = File.basename(xcworkspace, ".xcworkspace")
        sample_project_name = "#{project_name}Sample"
        workspace_dir = File.dirname(xcworkspace)
        xml_document = workspace.document
        if params[:ios_available] == false
          self.remove_project(workspace_dir, xml_document, all_xcodeprojs_map, sample_project_name, "iOS")
        end
        if params[:watchos_available] == false
          self.remove_project(workspace_dir, xml_document, all_xcodeprojs_map, sample_project_name, "watchOS")
        end
        if params[:tvos_available] == false
          self.remove_project(workspace_dir, xml_document, all_xcodeprojs_map, sample_project_name, "tvOS")
        end
        if params[:osx_available] == false
          self.remove_project(workspace_dir, xml_document, all_xcodeprojs_map, sample_project_name, "OSX")
        end
        workspace.save_as(xcworkspace)
      end

      def self.remove_project(workspace_dir, xml_document, all_xcodeprojs_map, project_name, platform)
        project_name = "#{project_name}-#{platform}"
        if xcodeproj = all_xcodeprojs_map[project_name]
          self.rm_directory(File.dirname(xcodeproj.absolute_path(workspace_dir)))
          xml_document.delete_element("/Workspace/FileRef[@location=\"#{xcodeproj.type}:#{xcodeproj.path}\"]")
        end
      end

      def self.rm_directory(path)
        if File.directory?(path)
          Dir.foreach(path) do |file|
            file_name = file.to_s
            if ((file_name != ".") && (file_name != ".."))
              self.rm_directory(File.join(path, file))
            end
          end
          Dir.delete(path)
        else
          File.delete(path)
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Remove unused project from the Xcode workspace"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcworkspace,
                                       description: "The Xcode workspace path",
                                       env_name: "XCWORKSPACE",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ios_available,
                                       description: "iOS available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_IOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :watchos_available,
                                       description: "watchOS available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_WATCHOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :tvos_available,
                                       description: "tvOS available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_TVOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :osx_available,
                                       description: "OSX available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_OSX_AVAILABLE",
                                       is_string: false,
                                       default_value: true)
        ]
      end

      def self.authors
        ["bbriatte"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.category
        :project
      end
    end
  end
end
