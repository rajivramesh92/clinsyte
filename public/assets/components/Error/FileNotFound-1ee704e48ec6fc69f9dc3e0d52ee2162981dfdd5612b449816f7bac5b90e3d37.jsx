class FileNotFound extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className = 'page-wrapper'>
        <div className = 'container'>
          <div className = 'col-md-6 col-md-offset-3'>
            <div className = 'logo'>
              <img src = { APP_LOGO } />
            </div>
            <div className = 'text-center'>
              <h2>404</h2>
            </div>
            <div className = 'row'>
              <div className = 'col-md-4 col-md-offset-4 blue line'></div>
            </div>
            <p className = 'text-center large-text'>Sorry, the page you are looking for does not exist</p>
            <p className = 'text-center large-text'>
              Take me to <Link to = '/home'>Home</Link>
            </p>
          </div>
        </div>
      </div>
    )
  }
}
