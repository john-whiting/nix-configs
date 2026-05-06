{
  unstable,
  ...
}:
{
  ...
}:
{
  plugins.minuet = {
    enable = true;
    package = unstable.vimPlugins.minuet-ai-nvim;
    settings = {
      blink = {
        enable_auto_complete = true;
      };
      provider = "gemini";
      provider_options = {
        openai = {
          api_key.__raw = ''
            function() return agenix_secrets["api-ai-openai"] end
          '';

          optional = {
            max_completion_tokens = 128;
            # for thinking models
            reasoning_effort = "none";
            # reasoning_effort = "minimal";
            # Set to "minimal" if your chosen model doesn't support "none"
          };
        };
        gemini = {
          model = "gemini-2.5-flash";
          api_key.__raw = ''
            function() return agenix_secrets["api-ai-gemini"] end
          '';
          stream = false;

          optional = {
            generationConfig = {
              maxOutputTokens = 256;
              thinkingConfig = {
                # Disable thinking for gemini 2.5 models
                thinkingBudget = 0;
                # Disable thinking for gemini 3.x models
                # thinkingLevel = "minimal";
              };
            };
            safetySettings = [
              {
                # HARM_CATEGORY_HATE_SPEECH,
                # HARM_CATEGORY_HARASSMENT
                # HARM_CATEGORY_SEXUALLY_EXPLICIT
                category = "HARM_CATEGORY_DANGEROUS_CONTENT";

                # BLOCK_NONE
                threshold = "BLOCK_ONLY_HIGH";
              }
            ];
          };
        };
      };
    };
  };
}
