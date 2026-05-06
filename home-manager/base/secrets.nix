{
  secrets,
  ...
}:
{
  age.secrets.api-ai-gemini.file = "${secrets}/api-ai-gemini.age";
  age.secrets.api-ai-openai.file = "${secrets}/api-ai-openai.age";
}
