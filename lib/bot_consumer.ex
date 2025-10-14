defmodule MusicBot.BotConsumer do
  @behaviour Nostrum.Consumer

  alias Nostrum.Api
  alias MusicBot.Commands
  alias MusicBot.Ideas
  alias MusicBot.Choose

  alias Nostrum.Struct.Event.MessageReactionAdd
  alias Nostrum.Struct.Event.MessageReactionRemove

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    _message =
      case Api.Message.get(msg.channel_id, msg.id) do
        {:ok,
         %Nostrum.Struct.Message{
           content: content
         }} ->
          content

        _ ->
          ""
      end

    cond do
      true ->
        :ignore
    end
  end

  def handle_event({:READY, %Nostrum.Struct.Event.Ready{} = _event, _ws_state}) do
    Commands.command_list()
    |> Enum.map(fn command ->
      ["1024715933845045329"]
      |> Enum.map(fn id ->
        Api.ApplicationCommand.create_guild_command(id, command)
      end)
    end)
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "idea", options: [%{name: "idea", value: idea}]}
         } = interaction, _ws_state}
      ) do
    Api.Interaction.create_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "Thanks for the idea bb"
      }
    })

    {:ok, response} =
      Api.Message.create(
        interaction.channel_id,
        "#{interaction.user.username} has submitted the idea \"#{idea}.\""
      )

    MusicBot.Ideas.create(%{
      idea: idea,
      author: interaction.user.username,
      votes: 0,
      message_id: Integer.to_string(response.id),
      user_id: Integer.to_string(interaction.member.user_id)
    })

    Api.Message.react(interaction.channel_id, response.id, "%F0%9F%91%8D")
  end

  # List all idears
  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "list"}
         } = interaction, _ws_state}
      ) do
    ideas =
      Ideas.get_all()
      |> Enum.map(fn idea ->
        String.pad_trailing(Integer.to_string(idea.votes), 5, " ") <>
          String.pad_trailing(idea.author, 20, " ") <> idea.idea
      end)
      |> Enum.join("\n")

    Api.Interaction.create_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "\n```" <> ideas <> "```"
      }
    })
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "bully", options: [%{name: "name", value: name}]}
         } = interaction, _ws_state}
      ) do
    bully_phrases = [
      "Hey #{name}, the clock is ticking! Pick a song before you become the reason we lose this round! ⏰",
      "#{name}, your procrastination skills are impressive, but Music League needs a song pick more than your indecision! 🎵",
      "Listen up #{name}, that submit button won't click itself! Get moving! 🔥",
      "#{name}, while you're sitting there contemplating life, the deadline is approaching faster than your last-minute panic! ⚡",
      "Yo #{name}! The only thing worse than your music taste would be not picking anything at all! 😤",
      "#{name}, stop scrolling through your playlist like you're choosing a life partner and just pick something! 📱",
      "#{name}, tick tock goes the clock, but your song selection is moving at the speed of molasses! 🐌",
      "Hey #{name}, remember that time you said you'd pick a song? Yeah, me neither, because you still haven't! 🤔",
      "#{name}, your indecisiveness is so legendary, it should have its own Wikipedia page! Pick a song already! 📖",
      "#{name}, I've seen glaciers move faster than your song selection process! Speed it up! 🧊",
      "#{name}, the suspense of waiting for your pick is killing us... literally! Save us from this agony! 💀",
      "#{name}, at this rate, the Music League round will end before you even open Spotify! Move it! 🏃‍♂️",
      "#{name}, your playlist paralysis is showing! Just close your eyes and pick something, anything! 👀",
      "#{name}, I bet you take longer to pick a song than it takes to actually listen to one! Prove me wrong! 🎧",
      "#{name}, the deadline is breathing down your neck like a hungry dragon! Feed it a song pick! 🐲",
      "#{name}, your hesitation is so intense, it could power a small city! Channel that energy into picking a song! ⚡",
      "#{name}, even a Magic 8-Ball makes decisions faster than you! Shake things up and submit something! 🎱",
      "#{name}, your music library is crying from neglect! Show it some love and pick a track! 😢",
      "#{name}, I've watched paint dry with more excitement than waiting for your song choice! Let's go! 🎨",
      "#{name}, you're treating this like a life-or-death decision when it's just Music League! Pick something fun! 🎭",
      "#{name}, your overthinking could win Olympic gold! Now use that determination to submit a song! 🥇",
      "#{name}, the only thing missing from your playlist browsing is a rocking chair and some knitting! Speed up! 🪑",
      "#{name}, you've got more songs than a jukebox but the commitment of a ghost! Make it happen! 👻",
      "#{name}, even snails are judging your song selection speed right now! Don't let them win! 🐌",
      "#{name}, your procrastination game is so strong it deserves its own soundtrack! But first, pick a song for us! 🎼"
    ]

    random_phrase = Enum.random(bully_phrases)

    Api.Interaction.create_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: random_phrase
      }
    })
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "pick"}
         } = interaction, _ws_state}
      ) do
    idea = MusicBot.Vote.pick()

    Api.Interaction.create_response(interaction, %{
      type: 4,
      data: %{
        content: "The next theme is: \"" <> idea.idea <> "\" by *" <> idea.author <> "*"
      }
    })

    # Get the message ID from the response
    case Api.Interaction.original_response(interaction) do
      {:ok,
        %Nostrum.Struct.Message{
          id: message_id
        }} ->
        Choose.store_pick(message_id, idea, interaction)

      _ ->
        :original_response_not_found
    end
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "ryansucks"}
         } = interaction, _ws_state}
      ) do
    Api.Interaction.create_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "Ryan sucks, he is the worst."
      }
    })
  end

  def handle_event({:MESSAGE_REACTION_ADD, %MessageReactionAdd{} = reaction, _ws_state}) do
    MusicBot.Vote.reaction_add(reaction)
    MusicBot.Choose.reaction_add(reaction)
  end

  def handle_event({:MESSAGE_REACTION_REMOVE, %MessageReactionRemove{} = reaction, _ws_state}) do
    MusicBot.Vote.reaction_remove(reaction)
    MusicBot.Choose.reaction_remove(reaction)
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event({event_name, _, _}) do
    event_name |> IO.inspect()
    :noop
  end
end
