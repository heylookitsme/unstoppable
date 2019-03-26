class Profiles::BuildController < ApplicationController
    include Wicked::Wizard
    layout "sidebar_non_admin"
    
    steps :about_me, :cancer_history
  
    def show
      @profile = Profile.find(params[:profile_id])
      render_wizard
    end
  
  
    def update
      @profile = Profile.find(params[:profile_id])
      @profile.update_attributes(params[:profile])
      render_wizard @profile
    end
  
  
    #def create
     # @product = Product.create
     # redirect_to wizard_path(steps.first, product_id: @product.id)
    #end
  end
  