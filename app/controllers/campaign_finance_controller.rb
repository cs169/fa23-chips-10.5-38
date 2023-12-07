# frozen_string_literal: true

class CampaignFinanceController < ApplicationController
  def index
    @cycle = CampaignFinance.cycle
    @category = CampaignFinance.category.keys
  end

  def search
    @camp_res = CampaignFinance.get_top(params[:cycle], params[:category])
  end
end
