
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
  $(".col-md-4 .btn.btn-default").on "click", ->
    user_id = this.id
    text =  $('input.user_'+user_id).val()
    $.post(
      new_post_url(), { text: text, user_id: user_id }
    ).done( (response) ->
      return
    ).fail( ()->
      $('input').val("")
      return
    )
    return
  cur_time = $.now()/1000 | 0
  setInterval (->
    updatePosts(cur_time)
    return
    ), 1000


  return

long_polling = () ->

  return

http_streaming = () ->
  source = new EventSource('/chat/stream')
  source.onmessage = (response) ->
    parseResponse(JSON.parse(response.data))
  return

web_sockets = () ->
  dispatcher = new WebSocketRails('localhost:3000/websocket');
  channel = dispatcher.subscribe('new_post')

  $(".col-md-4 .btn.btn-default").on "click", ->
    user_id = this.id
    text =  $('input.user_'+user_id).val()
    dispatcher.trigger('chat.new_post', { text: text, user_id: user_id },
      (responce)->
        return
      (response) ->
        $('input').val("")
        return
    );

    return


  channel.bind 'post_created', (response) ->
    parseResponse(JSON.parse(response))
    return
  return

@updatePosts=(cur_time)->
  last_post = $("li").last()
  if  last_post.length > 0
    last_post_id = parseInt(last_post.attr("id"))

  url = "/chat/new_posts"
  $.get(url, { last_post_id: last_post_id, cur_time: cur_time }
  ).done((response)->
    parsed_res = JSON.parse(response.posts)
    $.each parsed_res, (k, post) ->
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
        return  "<li id='"+response.id+"'  style='color:green;' >"+ response.author.username + ": => " + response.content+"</li>"
      else
        return  "<li id='"+response.id+"' >"+ response.author.username + ": => " +response.content+"</li>"
  )
  $('input').val("")
  return

new_post_url=() ->
  "/chat"
