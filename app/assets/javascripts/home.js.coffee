
$(document).on 'ready page:load', ->
  connection_type = parseInt($.cookie('connection_type'))
  switch connection_type
    when 1
      short_polling()
    when 2
      long_polling()
    when 3
      http_streaming()
    when 4
      web_sockets()


  return


short_polling = () ->
  cur_time = $.now()/1000 | 0
  setInterval (->
    updatePosts(cur_time)
    return
    ), 1000


  return

long_polling = () ->

  return

http_streaming = () ->

  return

web_sockets = () ->
  dispatcher = new WebSocketRails('localhost:3000/websocket');
  channel = dispatcher.subscribe('new')

  $(".col-md-4 .btn.btn-default").on "click", ->
    user_id = this.id
    text =  $('input.user_'+user_id).val()
    dispatcher.trigger('chat.new', { text: text, user_id: user_id },
      (responce)->
        return
      (response) ->
        $('input').val("")
        return
    );

    return


  channel.bind 'new_post', (response) ->
    parseResponse(response)
    return
  return

@updatePosts=(cur_time)->
  last_post = $("li").last()
  if  last_post.length > 0
    last_post_id = parseInt(last_post.attr("id"))

  url = "/chat/new_posts"
  $.get(url, { last_post_id: last_post_id, cur_time: cur_time }
  ).done((response)->
    $.each response.posts, (k, post) ->
      parseResponse(post)
      return
  ).fail( (response) ->
    $('input').val("")
  )
  return

parseResponse=(response)  ->
  $(".row ul").append(
    ()->
      if this.className == "user_" + response.user_id
        return  "<li id='"+response.id+"'  style='color:green;' >"+response.content+"</li>"
      else
        return  "<li id='"+ response.id +"'>"+response.content+"</li>"
  )
  $('input').val("")
  return