class Search
  RESOURSES = %w[All Questions Answers Comments Users].freeze

  def self.find(query, resourse)
    return nil if query.try(:blank?) || !RESOURSES.include?(resourse)
    resourse == 'All' ? ThinkingSphinx.search(query) : ThinkingSphinx.search(query, classes: [model_klass(resourse)])
  end

  private

  def self.model_klass(resourse)
    resourse.classify.constantize
  end
end