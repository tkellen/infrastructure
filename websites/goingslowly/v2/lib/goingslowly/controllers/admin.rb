module GS
  class App < Sinatra::Base
    subdomain :journal do

      ##
      # Preview page for journal editing.
      #
      get '/preview/:id' do
        protected!
        noCache
        journal = Journal[params[:id]]
        pass if journal.nil?

        slim :journal_entry, {
          :layout => request.xhr? ? false : :layout_journal,
          :locals => journal.context(request.xhr?)
        }
      end

    end
  end
end
