"""Streamlit app for experimentation prompt entry and workflow trigger."""
import os

import requests
import streamlit as st

status_code_ok = 200

st.title("Agentic Fraud Detection Experimentation")
st.write("Enter your experiment instruction for the agentic DS team. The workflow will be triggered and you will see the status and results below.")

prompt = st.text_area("Experiment Instruction", "Train a fraud binary classifier using the latest transaction data.")

class ExperimentSubmissionError(Exception):
    """Custom exception for experiment submission errors."""

def submit_experiment(prompt: str, timeout: int = 30) -> dict:
    """Submit the experiment prompt to the agentic API and return the result."""
    api_url = os.environ.get("AGENTIC_API_URL", "http://localhost:8000/trigger")
    response = requests.post(api_url, json={"instruction": prompt}, timeout=timeout)
    if response.status_code == status_code_ok:
        return response.json()
    error_msg = f"Error: {response.status_code} - {response.text}"
    raise ExperimentSubmissionError(error_msg)

if st.button("Submit Experiment"):
    with st.spinner("Submitting experiment to agentic team..."):
        try:
            result = submit_experiment(prompt)
            st.success("Experiment submitted!")
            st.write("**Agentic Team Response:**")
            st.json(result)
        except Exception as e:
            st.error(f"Failed to submit experiment: {e}")

st.markdown("---")
st.write("This app triggers the full agentic DS workflow on Cloud managed infrastructure.")
