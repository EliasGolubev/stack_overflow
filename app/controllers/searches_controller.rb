class SearchesController < ApplicationController
  before_action :load_query
  before_action :load_resourse

  skip_authorization_check

  def show
    @result = Search.find(@query, @resourse) if @query.present?
  end

  private

  def load_query
    @query = params[:query]
  end

  def load_resourse
    @resourse = params[:resourse]
  end
end