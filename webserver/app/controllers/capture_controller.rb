require 'will_paginate/array'
class CaptureController < ApplicationController
  #protect_from_forgery :only => [:clone, :extract, :calibrate]
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html
  # create and update are protected by recaptcha

  skip_before_filter :verify_authenticity_token

  def index
    if logged_in?
      @calibration = current_user.last_calibration
      @calibration = Spectrum.find(params[:calibration_id]) if params[:calibration_id]
      @start_wavelength,@end_wavelength = @calibration.wavelength_range if @calibration
    end
    @spectrums = Spectrum.find(:all, :limit => 12, :order => "id DESC")
    if params[:alt] == "true"
      render :template => "capture/index-mobile-alt.html.erb", :layout => "bootstrap"
    elsif mobile?
      render :template => "capture/index-mobile.html.erb", :layout => "mobile"
    end
  end

  # older match interface; displaced by new match controller
  def match
    @set = SpectraSet.find params[:id]
    if logged_in?
      @calibration = current_user.last_calibration
      @start_wavelength,@end_wavelength = @calibration.wavelength_range 
    end
    @calibration = Spectrum.find :last if APP_CONFIG['local']
    if mobile?
      render :template => "capture/index.mobile.erb", :layout => "mobile" 
    else
      render :template => "capture/index.html.erb"
    end
  end

end
