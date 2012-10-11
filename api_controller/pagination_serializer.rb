class PaginatedArraySerializer < ActiveModel::ArraySerializer
  def as_json(option = nil)
    hash = super
    hash.merge!(:total_entries => object.total_entries) if object.respond_to?(:total_entries)
    hash
  end
end

class ThinkingSphinx::Search
  def active_model_serializer
    PaginatedArraySerializer
  end
end

class WillPaginate::Collection
  def active_model_serializer
    PaginatedArraySerializer
  end
end