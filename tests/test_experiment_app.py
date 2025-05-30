"""Pytest tests for experiment_app.py (Streamlit app)."""
from unittest.mock import patch

from experiment_app import submit_experiment

TEST_PROMPT = "Test prompt"
TIMEOUT = 30


def test_submit_experiment_success() -> None:
    """Test successful experiment submission."""
    error_msg_payload = "POST payload incorrect"
    error_msg_timeout = "Timeout not set correctly"
    error_msg_result = "Result not as expected"
    with patch("experiment_app.requests.post") as mock_post:
        mock_post.return_value.status_code = 200
        mock_post.return_value.json.return_value = {"result": "success"}
        result = submit_experiment(TEST_PROMPT)
        if mock_post.call_args[1]["json"] != {"instruction": TEST_PROMPT}:
            raise AssertionError(error_msg_payload)
        if mock_post.call_args[1]["timeout"] != TIMEOUT:
            raise AssertionError(error_msg_timeout)
        if result != {"result": "success"}:
            raise AssertionError(error_msg_result)


def test_submit_experiment_exception() -> None:
    """Test experiment submission exception handling."""
    error_msg = "Exception message mismatch"
    error_not_raised = "Exception not raised"
    with patch("experiment_app.requests.post") as mock_post:
        mock_post.side_effect = Exception("Network error")
        try:
            submit_experiment(TEST_PROMPT)
        except Exception as exc:
            if "Network error" not in str(exc):
                raise AssertionError(error_msg) from exc
        else:
            raise AssertionError(error_not_raised)
