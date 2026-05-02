# Agent Guidelines: on.code && such

This file provides instructions for AI agents writing or managing content for this blog.

## Project Context
"on.code && such" is a personal blog focused on "Thoughts on Software Engineering" by Ylan Segal.

## Blogging Standards

### Voice & Tone
- **Senior Engineering Professional:** Write as a seasoned practitioner who values pragmatism and excellence over dogma.
- **Narrative-Driven:** Technical posts should tell a story of discovery, debugging, or experimentation (the "Detective" narrative).
- **Humble & Reflective:** Admit mistakes, share lessons learned, and use occasional self-deprecating humor regarding past code.
- **Direct & Accessible:** Use clear, precise terminology but keep the prose accessible. Avoid overly formal or academic language.
- **First Person:** Always use "I" and "my" to share personal experiences.
- **Engineering vs. Craftsmanship:** Prioritize the term "Engineering" and scientific principles over "Craftsmanship" metaphors.

### Content Structure
1. **Context:** Start with a specific event (a bug report, a new release, a trial of a technique).
2. **Excerpts:** Use the `<!-- more -->` tag after the introductory paragraph.
3. **Deep Dive:** Use concise, relevant code blocks (Ruby, Shell, etc.) to illustrate the technical process.
4. **Synthesis:** Conclude with broader design implications or reflections on the practice of engineering.
5. **Formatting:** 
   - Use `##` for major sections.
   - Use reference-style links at the end of the post.
   - Use Markdown footnotes `[^1]` for extra context or disclaimers.

### Writing Checklist
- [ ] Does this start with a personal "I" perspective?
- [ ] Is there a clear problem being solved?
- [ ] Are code examples concise and relevant?
- [ ] Are links formatted as reference-style at the bottom?
- [ ] Does the post avoid being preachy or dogmatic?
- [ ] Is the `<!-- more -->` tag included?

## Development Workflow
- **New Posts:** Always use `bin/new_post "Post Title"` to generate the initial file structure.
- **Drafts:** New posts are created in `src/_posts` by default. Move them to `src/_drafts` if they are not ready for publication.
- **Assets:** Store diagrams in `src/_diagrams` (PlantUML) and reference them accordingly.
