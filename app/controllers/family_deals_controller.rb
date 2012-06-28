
class FamilyDealsController < ApplicationController
  def index
    @family_deals = FamilyDeal.all
  end

  def new
    @deal = FamilyDeal.new
    @living_social_deals = get_families_deals
  end

  def create
    old_families_deals = FamilyDeal.all
    old_families_deals_titles = old_families_deals.collect do |deal|
      deal.long_title
    end
    build_new_families_deals(old_families_deals_titles)
    redirect_to family_deals_path
  end
  
  private

  def get_families_deals
    family_deals = LivingSocialDeal.where(deal_type:"FamiliesDeal")
    us_deals_with_address = []
    family_deals.each do |deal|
      if deal.country_code = "US" && deal.address1 != nil
        us_deals_with_address << deal
      end
    end
    us_deals_with_address
  end

  def build_new_families_deals(old_families_deals_titles)
    get_families_deals.each do |deal|
      unless old_families_deals_titles.include?(deal.long_title)
        create_new_families_deal(deal)
        create_activity(deal)
      end
    end
  end

  def create_new_families_deal(deal)
    new_deal = FamilyDeal.new
    new_deal.long_title = deal.long_title
    new_deal.deal_type = deal.deal_type
    new_deal.market_name = deal.market_name
    new_deal.country_code = deal.country_code
    new_deal.categories = deal.categories
    new_deal.address1 = deal.address1
    new_deal.address2 = deal.address2
    new_deal.city = deal.city
    new_deal.state = deal.state
    new_deal.zip = deal.zip
    new_deal.country = "USA"
    new_deal.save
  end

  def create_activity(deal)
    new_activity = Activity.new
    new_activity.name = deal.long_title
    new_activity.street = deal.address1
    new_activity.city = deal.city
    new_activity.country = "USA"
    new_activity.deal = true
    new_activity.save
  end
end