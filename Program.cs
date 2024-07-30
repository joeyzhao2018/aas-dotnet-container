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
    using (DogStatsd.StartTimer("joey.timer", tags: new[] { "user:joey" }))
    {
        Thread.Sleep(1000);
        Console.WriteLine("Hi, joey timer 1.2.1");
    }
    return "Hi, timer 1.2.1";
});

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
