# frozen_string_literal: true

class RepresentativesController < ApplicationController
  def index
    @representatives = Representative.all
  end

  # Added this in to show profile page of representative
  def show
    @representative = Representative.find_by(id: params[:id])
    if @representative.nil?
      redirect_to representatives_path, alert: 'no one found'
    else
      render :show
    end
  end
end
