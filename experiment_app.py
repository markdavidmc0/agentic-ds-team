"""Streamlit app for experimentation prompt entry and workflow trigger."""
import os

import requests
import streamlit as st

status_code_ok = 200


st.title("Agentic Fraud Detection Experimentation")
st.write("Enter your experiment instruction for the agentic DS team. The workflow will be triggered and you will see the status and results below.")

api_url = os.environ.get("AGENTIC_API_URL", "http://localhost:8000/trigger")

prompt = st.text_area("Experiment Instruction", "Train a fraud binary classifier using the latest transaction data.")

if st.button("Submit Experiment"):
    with st.spinner("Submitting experiment to agentic team..."):
        try:
            response = requests.post(api_url, json={"instruction": prompt}, timeout=10)
            if response.status_code == status_code_ok:
                result = response.json()
                st.success("Experiment submitted!")
                st.write("**Agentic Team Response:**")
                st.json(result)
            else:
                st.error(f"Error: {response.status_code} - {response.text}")
        except Exception as e:
            st.error(f"Failed to submit experiment: {e}")

st.markdown("---")
st.write("This app triggers the full agentic DS workflow on AWS Bedrock Agents and SageMaker.")
