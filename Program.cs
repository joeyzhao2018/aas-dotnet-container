using StatsdClient;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.MapGet("/timer", () =>
{
    var dogstatsdConfig = new StatsdConfig
        {
            StatsdServerName = "127.0.0.1",
            StatsdPort = 8125,
        };

    using (var dogStatsdService = new DogStatsdService())
    {
        if (!dogStatsdService.Configure(dogstatsdConfig))
            throw new InvalidOperationException(
                "Cannot initialize DogstatsD. Set optionalExceptionHandler argument in the `Configure` method for more information.");
        dogStatsdService.Increment("joey.increment", tags: new[] {"user:joey"});

        using (dogStatsdService.StartTimer("joey.timer", tags: new[] { "user:joey" }))
        {
            Thread.Sleep(1000);
            Console.WriteLine("Hi, joey timer 1.2.1");
        }
    }


    return "Hi, timer configured";
});

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
