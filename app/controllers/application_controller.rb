class ApplicationController < ActionController::Base
  # before_action :redirect_shutdown
  require 'carmen'
  before_action :set_price
  include Carmen
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def grid_table_for(resource, params, options = {})
    grid_table = resource.grid_table
    grid_table.populate!(resource, params)

    if block_given?
      yield grid_table.records, grid_table.total_rows
    else
      rows = []

      local = options[:local].try(:to_sym) || grid_table.records.klass.name.demodulize.downcase.to_sym
      grid_table.records.each do |record|
        rows << (render_to_string partial: (options[:partial] || 'row'), locals: { local => record })
      end

      render json: { total_rows: grid_table.total_rows, rows: rows }
    end
  end

  private
  
  def set_price
    price_row = ProductPrice.first
    if price_row
      @price = price_row.price.to_f
    else
      @price = 49.95
    end
  end
  def redirect_shutdown
    unless controller_name == 'home' && action_name == 'index'
      redirect_to root_url
    end
  end
end
