# frozen_string_literal: true

class FileMetaData
  attr_reader :file_type, :permissions, :links, :owner, :group, :size, :last_modified

  def initialize(attributes)
    @file_type = attributes[:file_type]
    @permissions = attributes[:permissions]
    @links = attributes[:links]
    @owner = attributes[:owner]
    @group = attributes[:group]
    @size = attributes[:size]
    @last_modified = attributes[:last_modified]
  end
end
