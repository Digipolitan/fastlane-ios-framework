module Fastlane
  module Actions
    module SharedValues
    end

    class EditXcworkspaceAction < Action
      def self.run(params)
        xcworkspace = params[:xcworkspace]
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
        "A short description with <= 80 characters of what this action does"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcworkspace,
                                       env_name: "XCWORKSPACE",
                                       description: "The workspace path",
                                       verify_block: proc do |value|
                                       end),
          FastlaneCore::ConfigItem.new(key: :ios_available,
                                       env_name: "FRAMEWORK_IOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :watchos_available,
                                       env_name: "FRAMEWORK_WATCHOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :tvos_available,
                                      env_name: "FRAMEWORK_TVOS_AVAILABLE",
                                      is_string: false,
                                      default_value: true),
          FastlaneCore::ConfigItem.new(key: :osx_available,
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
    end
  end
end
