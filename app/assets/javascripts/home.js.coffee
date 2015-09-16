
$(document).on 'ready page:load', ->

  dispatcher = new WebSocketRails('localhost:3000/websocket');
  channel = dispatcher.subscribe('new')

  $(".col-md-4 .btn.btn-default").on "click", ->
    user_id = this.id
    text =  $('input.user_'+user_id).val()
    dispatcher.trigger('chat.new', { text: text, user_id: user_id },
      (responce)->

        return

      (response) ->
        $('input.user_'+user_id).val("")
        return
    );

    return


  channel.bind 'new_post', (response) ->
    $(".row ul").append(
      ()->
        if this.className == "user_" + response.user_id
          return  "<li style='color:green;'>"+response.content+"</li>"
        else
          return  "<li>"+response.content+"</li>"
    )
    $('input').val("")
    return

  return