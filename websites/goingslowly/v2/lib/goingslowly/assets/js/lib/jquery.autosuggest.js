(function($)
{
  $.autosuggest = function(el, settings)
  {
     var base = this;

     base.el = $(el); // shorthand to called element
     base.el.data("autosuggest",base); // allow entry from dom

     // default state
     var state =
     {
       defer: false,
       last:'',
       loaded: false,
       results:false
     };

     // initialize autosuggest
     base.init = function()
     {
       base.settings = $.extend({},$.autosuggest.settings,settings);
       var s = base.settings;

       // bind keyup to input field
       base.el.bind('keyup',function()
       {
         // if search was already scheduled, clear it
         if(state.defer) clearTimeout(state.defer);
         
         // schedule search
         state.defer = setTimeout(function()
         {
           // get search term
           var q = base.el.val().toLowerCase();

           // run search
           base.search(q);
         },s.delaySearch);
       });
       
       // create results element
       state.results = $('<ul class="as"></ul>');
       
       // flag results to close after mouseout
       state.results.hover
       (
         function(){clearTimeout(state.closing);},
         function(){state.closing=setTimeout(base.close,s.delayClose)}
       );
       
       // insert results
       $('body').append(state.results);
     };

     // close search results
     base.close = function()
     {
       var s = base.settings;
       state.last='';
       state.results.fadeOut('fast');
     };

     // run search
     base.search = function(q)
     {
       var s = base.settings;

       // skip scheduling a search for the same text
       if(state.last == q) return;
       
       // skip searching if chars are less than minimum allowed
       if(q.length < s.minChars)
       {
         // if results are already open, close if backspaces below minimum
         state.results.fadeOut('fast');
         return;
       }
       
       // save last search to prevent repeats
       state.last = q;

       // if flagged to do so, highlight portions of matched text
       if(s.highlight)
       {
         // cache highlight regexp
         var regx = new RegExp('(?![^&;]+;)(?!<[^<>]*)('+q+')(?![^<>]*>)(?![^&;]+;)','gi');
       }
       var match = html = [];
       
       // perform search backwards
       var i = s.data.length;
       while(i--)
       {
         // search each object in data for matching text
         if(s.data[i][s.key].toLowerCase().search(q)!=-1)
         {
           var prefix = s.data[i][s.prefix]||'';
           var key = s.data[i][s.key];
           var val = s.data[i][s.val];
           
           // if flagged to do so, highlight found results
           if(s.highlight) key = key.replace(regx,"<em>$1</em>");
           
           // add result to html
           html.push('<li><a href="'+val+'">'+prefix+''+key+'</a></li>');
         }
       }
       
       // if any results are found
       if(match.length)
       {
         // determine position of input field
         var pos = base.el.offset();
         
         // build results html element
         var list = $(html.join(''));
         
         // insert results
         state.results.css({top:pos.top+s.offsetTop,left:pos.left+s.offsetLeft})
                      .html(list)
                      .fadeIn('fast');
       }
     };

     base.init();
  };
  $.fn.autosuggest = function(s){return this.each(function(){(new $.autosuggest(this,s));});};

  $.autosuggest.settings =
  {
    data:{}, // JSON data to search
    delaySearch:100, // delay from last typed letter before searching
    delayClose:1500, // delay to close results after mouseout
    minChars:3, // minimum number of characters required to start search
    key:'name', // data object property name for field to search
    val:'url', // data object property name for url of hit
    prefix:'prefix', // data object property name for prefixed hits
                       // this should be placed at the end of the object
                       // so they display first
    offsetTop:0, // offset placement of results from top
    offsetLeft:0, // offset placement of results from left
    highlight:true // true of matching portion of word should be highlighted
  };
})(jQuery);
