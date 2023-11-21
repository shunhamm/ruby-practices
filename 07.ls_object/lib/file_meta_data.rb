# frozen_string_literal: true

class FileMetaData
  attr_reader :file_type, :permissions, :links, :owner, :group, :size, :last_modified

  def initialize(file_type:, permissions:, links:, owner:, group:, size:, last_modified:)
    @file_type = file_type
    @permissions = permissions
    @links = links
    @owner = owner
    @group = group
    @size = size
    @last_modified = last_modified
  end
end
