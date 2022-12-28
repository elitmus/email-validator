import React, { useState } from "react";
import { GoogleLogin } from "react-google-login";
const clientId = "";

const GLogin = (props) => {
  const [showSpinner, setShowSpinner] = useState(false);

  const onSuccess = (res) => {
    setShowSpinner(true);
    const email = res.profileObj.email;
    const password = res.profileObj.googleId;
    let data = {
      access_token: res.tokenObj.access_token,
      email: email,
      name: res.profileObj.givenName + " " + res.profileObj.familyName,
      username: email.substring(0, email.lastIndexOf("@")),
      password: password,
    };
    const token = document.querySelector("[name=csrf-token]").content;
    fetch("/api/v1/users/check", {
      method: "POST",
      headers: {
        "X-CSRF-Token": token,
        Accept: "application/json",
        "Content-type": "application/json",
      },
      body: JSON.stringify(data),
    }).then((result) => {
      result.json().then((resp) => {
        setShowSpinner(false);
        if (!resp.error) {
          localStorage.setItem("jwt", JSON.stringify(resp.jwt));
          localStorage.setItem("user", JSON.stringify(resp.user));
          const payload = {
            token: resp.jwt,
            user: resp.user,
            isLoggedIn: true,
          };
          const payload1={
            successAlert:true,
            errorAlert:false,
            strongMessage: "Success!",
            message:"You are successfully logged in"
          }
          props.onSuccessfulLogin(payload,payload1);
        } else {
            const payload={
              successAlert:false,
              errorAlert:true,
              strongMessage: "Error!",
              message:"Something went wrong please try again!"
            }
          props.onFailureGoogleLogin(payload)
        }
      });
    });
  };
  const onFailure = (res) => {
    const payload={
      successAlert:false,
      errorAlert:true,
      strongMessage: "Error!",
      message:"Something went wrong please try again!"
    }
    props.onFailureGoogleLogin(payload)
  };
  return (
    <div className='text-center text-dark mb-4'>
      <GoogleLogin
        clientId={clientId}
        buttonText='Sign In with Google'
        onSuccess={onSuccess}
        onFailure={onFailure}
        cookiePolicy={"single_host_origin"}
      >
        {!showSpinner ? (
          <span>Login With Google</span>
        ) : (
          <div
            className='spinner-border text-primary spinner-border-sm'
            role='status'
          >
            <span className='sr-only'>Loading...</span>
          </div>
        )}
      </GoogleLogin>
    </div>
  );
};
export default GLogin;
