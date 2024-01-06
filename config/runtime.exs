import Config
import Dotenvy

dir = System.get_env("RELEASE_ROOT") || "envs/"
source!([
  "#{dir}.env.#{config_env()}",
  System.get_env()
])

config :langchain, 
  openai_key: env!("OPENAI_API_KEY", :string)
