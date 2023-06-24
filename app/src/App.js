import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>

      <main>

	<article>
          <h3>Setup & configuration guide</h3>

          <p>
          <small>
          <b>
            This article assumes that you are running this application within
            a properly-configured environment.
          </b>
          </small>
          <br />
          <small>
          <b>
            The compiled image is designed only to support applications built with `create-react-app`.
          </b>
          </small>
          </p>

          <section>
            <h4>
              How to serve your own website
            </h4>

            <p>
              Dunno. Come back later.
            </p>

          </section>

        </article>

      </main>

      <footer>

        <p>
          If you need assistance, don't hesitate to get in touch by using
          our contact details, or via any of our social media!
        </p>

	{`<!--    TODO: Add contact details here.    -->`}

        <p class='copy'>
        <small>
          Copyright &copy; <span id='copyrightYear'>2023</span> Thugnerdz.
          All rights reserved.
        </small>
        </p>

      </footer>

    </div>
  );
}

export default App;
