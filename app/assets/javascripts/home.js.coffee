
$(document).on 'ready page:load', ->

  dispatcher = new WebSocketRails('localhost:3000/websocket');

  $(".col-md-4 .btn.btn-default").on "click", ->
    user_id = this.id
    text =  $('input.user_'+user_id).val()
    dispatcher.trigger('chat.new', { text: text },
      (responce)->
        $(".row ul").append(
          ()->
            if this.className == "user_" + user_id
              return  "<li style='color:green;'>"+text+"</li>"
            else
              return  "<li>"+text+"</li>"
        )
        $('input.user_'+user_id).val("")

        return

      (response) ->
        $('input.user_'+user_id).val("")
        return
    );

    return

  return