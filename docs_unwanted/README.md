# docs_unwanted/

Archived boilerplate. Not part of the project — kept for reference only, safe to delete.

| File | What it was | Why archived |
|------|-------------|--------------|
| `README.template.md` | "Best-README-Template" starter README | Generic placeholder shields, framework list, fake contacts — none of it described this project. |
| `Dockerfile.boilerplate` | `python:3.10` + `CMD python app.py` | Flask web-app scaffold. No `app.py` exists; project is an ISO builder, not a Python web app. |
| `requirements.boilerplate.txt` | `flask requests numpy` | Same leftover scaffold. Project has no Python runtime deps. |

Real build env (Docker Compose + Packer) lives on the `distro/rocky` and `distro/arch` branches.
