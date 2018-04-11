import "facebook-js-sdk";

interface IUserInfo {
    userId: string;
    accessToken: string;
    status: string;
    setLoginEvents(onLoggedIn: () => void, onLoggedOut: () => void);
}

class UserInfoImpl implements IUserInfo {

    private static _instance: UserInfoImpl = new UserInfoImpl();
    public static get Instance(): UserInfoImpl {
        return this._instance;
    }

    private _userId: string;
    get userId(): string { return this._userId || "unknown"; }
    private _accessToken: string;
    get accessToken(): string { return this._accessToken; }
    private _status: string;
    get status(): string { return this._status; }
    private onLoggedIn: () => void;
    private onLoggedOut: () => void;

    private constructor() {
        if (UserInfoImpl._instance) {
            throw new Error("Error: Instantiation failed: Use UserInfoImpl.getInstance() instead of new.");
        }
        UserInfoImpl._instance = this;
        FB.init({
            appId: '158511131519028',
            cookie: true,
            xfbml: true,
            version: 'v2.12'
        });
        FB.AppEvents.logPageView();
        FB.Event.subscribe("auth.statusChange", UserInfoImpl.Instance.facebookLogin);
        FB.getLoginStatus(UserInfoImpl.Instance.facebookLogin);
    }

    public setLoginEvents(onLoggedIn: () => void, onLoggedOut: () => void) {
        this.onLoggedIn = onLoggedIn;
        this.onLoggedOut = onLoggedOut;
        if (this._status == undefined || this._status === 'not_authorized') {
            if (this.onLoggedOut)
                this.onLoggedOut();
        } else if (this._status === 'connected') {
            if (this.onLoggedIn) this.onLoggedIn();
        }
    }

    private facebookLogin(response: fb.AuthResponse) {
        console.log(response);
        UserInfoImpl.Instance._status = response.status;
        if (response.status === 'connected') {
            // the user is logged in and has authenticated your
            // app, and response.authResponse supplies
            // the user's ID, a valid access token, a signed
            // request, and the time the access token 
            // and signed request each expire
            UserInfoImpl.Instance._userId = response.authResponse.userID;
            UserInfoImpl.Instance._accessToken = response.authResponse.accessToken;
            if (UserInfoImpl.Instance.onLoggedIn) UserInfoImpl.Instance.onLoggedIn();
        } else if (response.status === 'not_authorized') {
            // the user is logged in to Facebook, 
            // but has not authenticated your app
            UserInfoImpl.Instance._userId = undefined;
            UserInfoImpl.Instance._accessToken = undefined;
            if (UserInfoImpl.Instance.onLoggedOut) UserInfoImpl.Instance.onLoggedOut();
            FB.login(UserInfoImpl.Instance.facebookLogin/*, { scope: "user_education_history", return_scopes: true }*/);
        } else {
            // the user isn't logged in to Facebook.
            UserInfoImpl.Instance._userId = undefined;
            UserInfoImpl.Instance._accessToken = undefined;
            if (UserInfoImpl.Instance.onLoggedOut) UserInfoImpl.Instance.onLoggedOut();
            FB.login(UserInfoImpl.Instance.facebookLogin/*, { scope: "user_education_history", return_scopes: true }*/);
        }
    }
}


export const info: IUserInfo = UserInfoImpl.Instance;
