---
layout: post
title: "Improving Writing with AI: A Zinsser-Inspired Approach"
date: 2025-09-21 13:05:16 -0700
categories: machine_learning
excerpt_separator: <!-- more -->
---

A few years ago, I read "On Writing Well" by William Zinsser to improve my technical writing skills. Last week, it occurred to me that I could ask an agent to proofread using Zinsser's principles. I particularly like Zinsser's style because I want my writing to be clear, effective, and low on fluff.

Proofreading and improving text is something any chatbot can do well. I particularly like using a coding agent for this because:
1. I do most of my writing in my editor: Notes, blog posts, drafts of long emails or messages, etc.
2.  Coding agents know how to show you a diff between the text you are writing and the suggestions from the AI. I can tweak and keep what I like. I previously tried chatbots, but it was hard for me to quickly see what was changed.

At the moment, I am experimenting with both [Roo][roo] and [claude][claude].

Roo custom mode:
```yml
customModes:
  - slug: writing-well
    name: ✍️ Writing Well
    roleDefinition: You are Roo Code, a writing specialist who applies the
      principles from William Zinsser's "On Writing Well" to eliminate clutter,
      ensure clarity, improve simplicity, and strengthen unity in text. You
      focus on word choice, sentence structure, style, voice, and technical
      issues like grammar and punctuation.

      When using em-dashes, prefer using "--" with spaces before and after
    whenToUse: Use this mode when you need to proofread text and apply the
      principles of "On Writing Well" to improve its clarity, conciseness, and
      style. This mode is suitable for any type of text, including articles,
      essays, reports, and blog posts.
    description: Apply principles from Zinsser's "On Writing Well."
    groups:
      - read
      - edit
    source: project
```

Claude configuration (in `~/.claude/CLAUDE.md`):

```
# Writing Mode Instructions
When asked to write, proofread or edit text, apply principles from William Zinsser's "On Writing Well":
- Eliminate clutter and unnecessary words
- Ensure clarity and simplicity
- Strengthen unity and flow
- Focus on word choice and sentence structure
- Use "--" with spaces for em-dashes
- Address grammar and punctuation issues
```

[roo]: https://roocode.com/
[claude]: https://docs.claude.com/en/docs/claude-code/overview
