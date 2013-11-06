Printer Weather
------------------

(A demo [Printer][project page] application)

This app is designed to demonstrate automated scheduling of content for
printers, as opposed to the human-driven [mail][] and [paint][] apps.

This application can automatically send weather reports to printers in
the morning. [Find out more about printers][project page]. It’s really just an
example of how you can build a simple content provider for diminutive
internet printers.

You can [take a look at the source][source].

If you have a printer, and want to use this instance of Printer Weather
to get weather reports, you can [register here][].

If you don’t have a printer, **why not [find out how to get or make a
printer][project page] for yourself?**

How it works
------------

All this happens automatically **without user intervention, so in this
way “publications” can be scheduled to appear** at any time.

Weather ‘jobs’ are created by storing a print URL alongside IP-based
geocoding information, which is gathered to determine the location to be
used for forecasting. In a real application you would probably ask the
user for their location directly.

The `rake run` task is scheduled (in this case by Heroku, but possibly
by cron or anything else) to run at 8 am. At this time, it will send a
request for each job to its corresponding print URL, with the `url`
parameter set to a unique job URL in this app.

When the printer backend server requests that job URL, this app makes a
request to [the Wunderground API][] to determine the weather for today.
This is manipulated a bit, until average temperatures and weather
conditions for four periods during the day have been calculated.

These are then displayed in the output HTML using icons drawn with HTML5
canvas tags, appearing roughly [like this][example].

The printer backend server takes this page and rasterises it for the
destination printer to download.

More information
----------------

To find out more, you can take a look at any (or all) of the following:

-   The [introductory blog post][];
-   The [project page][];
-   The [backend server][backend server] we are running;
-   The [source for this app][source], the [mail app][mail], the
    [paint app][paint] or the
    [backend server itself][backend server source].

[example]: http://printer-weather.herokuapp.com/#example
[backend server]: http://printer.exciting.io
[register here]: http://printer-weather.herokuapp.com/register
[find out how to get or make a printer]: http://printer.exciting.io/getting-a-printer
[source]: https://github.com/exciting-io/printer-weather
[mail]: https://github.com/exciting-io/printer-mail
[paint]: https://github.com/exciting-io/printer-paint
[the Wunderground API]: http://wunderground.com
[introductory blog post]: http://exciting.io/2012/04/12/hello-printer/
[project page]: http://exciting.io/printer
[backend server source]: https://github.com/exciting-io/printer
