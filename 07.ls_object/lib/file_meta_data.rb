# frozen_string_literal: true

class FileMetaData
  attr_reader :name, :last_modified, :size, :permissions, :owner, :group

  def initialize(name:, last_modified:, size:, permissions:, owner:, group:)
    @name = name
    @last_modified = last_modified
    @size = size
    @permissions = permissions
    @owner = owner
    @group = group
  end
end
