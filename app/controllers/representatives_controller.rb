# frozen_string_literal: true

class RepresentativesController < ApplicationController
  def index
    @representatives = Representative.all
  end

  # Added this in to show profile page of representative
  # TODO
  def show
    @representative = Representative.find_by(id: params[:id])
    if !@representative.nil?
      render :show
    else
      redirect_to representatives_path, alert: "no one found"
    end
  end
end