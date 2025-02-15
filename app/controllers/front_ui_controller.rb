# Shadow Controller for the new front page
require 'will_paginate/array'

class FrontUiController < ApplicationController
  protect_from_forgery except: :save_location

  def index
    @maps = Map.new_maps.first(4)
    @unpaginated = true
    # TODO: these could use optimization but are better than prev:
    tag = Tag.where(name: 'featured').first
    @mappers = if tag
      User.where(login: tag.maps.collect(&:author), status: User::Status::NORMAL)
    else
      []
               end
  end

  def all_maps
    @maps = Map.new_maps
  end

  def nearby_mappers
    return unless current_location.present?

    lat = session[:lat]
    lon = session[:lon]
    @nearby_maps = Map.maps_nearby(lat: lat, lon: lon, dist: 10)
                      .page(params[:page])
                      .per_page(12)
    @nearby_mappers = User.where(login: Map.maps_nearby(lat: lat, lon: lon, dist: 10)
                                           .collect(&:author), status: User::Status::NORMAL)
                                           .paginate(page: params[:mappers], per_page: 12)
  end

  def save_location
    lat = params[:lat].to_f
    lon = params[:lon].to_f

    session[:lat] = lat
    session[:lon] = lon
    head(200, content_type: "text/html")
  end

  def about
    @map_count = Map.count
    @img_count = Warpable.count
  end

  def location
    @loc = params[:loc]

    @maps = Map.page(params[:page])
               .per_page(20)
               .where('status = ? and password = ? and location LIKE ?', Map::Status::NORMAL, '', "%#{@loc}%")
               .order('updated_at DESC')
               .group('maps.id')

    respond_to do |format|
      format.js
    end
  end

  def gallery
    @maps = Map.page(params[:page])
               .per_page(20)
               .where(status: Map::Status::NORMAL, password: '')
               .order('updated_at DESC')
               .group('maps.id')

    @authors = User.where(login: Map.featured.collect(&:author), status: User::Status::NORMAL)
                                    .paginate(page: params[:mappers], per_page: 20)
  end
end
