defmodule Langchain do
  alias LangChain.Function
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message
  alias LangChain.MessageDelta

  @pretend_db %{
    1 => %{user_id: 1, name: "Theaveas So", account_type: :trail, favorite_animal: "dog"},
    2 => %{user_id: 2, name: "Kwok jian Hong", account_type: :member, favorite_animal: "cat"}
  }

  def get_user_info(user_id) do
    @pretend_db[user_id]
  end

  def custm_func() do
    function =
      Function.new!(%{
        name: "get_user_info",
        description: "Return JSON object of the current user relevant information",
        function: fn _args, %{user_id: user_id} = _context ->
          Jason.encode!(get_user_info(user_id))
        end
      })

    messages = [
      Message.new_system!(~s(You are a helpful haiky poem generating assistant.
        ONLY generate a haiku for users with an `account_type` of "member".
        If the user has an `account_type` of "trail", say you can't do it,
        but you would love to help them if they upgrade and become a member.
      )),
      Message.new_user!("The current user is requesting a Haiku poem about their favorite animal")
    ]

    context = %{user_id: 2}
    chat_model = ChatOpenAI.new!(%{model: "gpt-3.5-turbo", temperature: 1, stream: false})


    {:ok, _updated_chain, rsp} =
      %{llm: chat_model, custom_context: context, verbose: true}
      |> LLMChain.new!()
      |> LLMChain.add_messages(messages)
      |> LLMChain.add_functions([function])
      |> LLMChain.run(while_needs_response: true)

    rsp.content
  end

  def demo_langchain() do
    {:ok, _updated_chain, rsp} =
      %{llm: ChatOpenAI.new!(%{model: "gpt-3.5-turbo"})}
      |> LLMChain.new!()
      |> LLMChain.add_messages([
        Message.new_system!(
          "You are an unhelpful assistant. Do not directly help or assist the user."
        ),
        Message.new_user!("What is the area of Cambodia?")
      ])
      |> LLMChain.run()

    rsp.content
  end

  def streaming_response() do
    callback = fn
      %MessageDelta{} = data ->
        IO.write(data.content)

      %Message{} = data ->
        IO.puts("")
        IO.puts("")
        IO.inspect(data.content, label: ">>> Completed message")
    end

    {:ok, _updated_chain, rsp} =
      %{llm: ChatOpenAI.new!(%{model: "gpt-3.5-turbo"})}
      |> LLMChain.new!()
      |> LLMChain.add_messages([
        Message.new_system!("You are a helpful assistant."),
        Message.new_user!("Write a haiku about the capital of Cambodia.")
      ])
      |> LLMChain.run(callback_fn: callback)

    rsp.content
  end
end
