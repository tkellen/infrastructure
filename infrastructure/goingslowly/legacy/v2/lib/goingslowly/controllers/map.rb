module GS
  class App < Sinatra::Base
    subdomain :map do

      ##
      # Main map page, show all locations in database at once.
      #
      get '/' do
        slim :map, {
          :layout => :layout_map,
          :locals => {
            :locations => Location.listing.all.map { |l| l.forMap }.to_json
          }
        }
      end

      ##
      # Map page for a given journal entry.
      # Show ending point and tracks in and out.
      # TODO: handle ?hidenav for caching
      #
      get %r{^/(?<year>20\d{2})/(?<month>\d{2})/(?<slug>[\w-]*)/?(?<junk>.*)$} do

        # hack off any extra junk from url and redirect to entry
        if !params[:junk].empty?
          redirect "/#{params[:year]}/#{params[:month]}/#{params[:slug]}", 301
        end

        noCache
        journal = Journal.lookup(params[:year],params[:month],params[:slug])
        pass if journal.nil?

        location = journal.locations.first
        pass if location.nil?

        slim :map_entry, {
          :layout => :layout_map,
          :locals => {
            :journal => journal,
            :location => location,
            :trackIn => location.trackIn,
            :trackOut => location.trackOut
          }
        }
      end

      ##
      # Build info window when marker is clicked on.
      #
      post '/infowindow' do
        puts Track.endingAt(params[:id]).all
        slim :map_infowindow, {
          :layout => false,
          :locals => {
            :trackIn => Track.endingAt(params[:id]).all.first,
            :trackOut => Track.startingAt(params[:id]).all.first,
            :location => Location.journalsForMapAt(params[:id]).first
          }
        }
      end

      post '/track' do
        track = Track[:id=>params[:id]]
        if track.nil?
          [].to_json
        else
          track.pointsForMap
        end
      end

    end
  end
end
