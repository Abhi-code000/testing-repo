DECLARE @Amount MONEY = 500;

BEGIN TRANSACTION;

-- Step 1: Deduct money from society
UPDATE GSTtblBankDetails
SET OpeningBalance = OpeningBalance - @Amount
WHERE BankId = 88;

-- Check if error occurred
IF @@ERROR <> 0
BEGIN
    ROLLBACK TRANSACTION;	
    PRINT '❌ Error while deducting from Society. Transaction rolled back.';
    RETURN;
END

-- Step 2: Credit money to worker
UPDATE GSTtblBankDetails
SET OpeningBalance = OpeningBalance + @Amount
WHERE BankId = 89;

-- Check if error occurred
IF @@ERROR <> 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT '❌ Error while crediting to Worker. Transaction rolled back.';
    RETURN;
END

-- If both successful
COMMIT TRANSACTION;
PRINT '✅ Transaction completed successfully!';


select * from  GSTtblBankDetails
<body>
    @{
        var profilePic = Session["ProfilePic"] != null && !string.IsNullOrEmpty(Session["ProfilePic"].ToString()) && !Session["ProfilePic"].ToString().Contains("default-profile.png")
                                ? Url.Content(Session["ProfilePic"].ToString())
                                : "";
        var staffName = Session["StaffName"] != null ? Session["StaffName"].ToString() : "User";
        var initialLetter = !string.IsNullOrEmpty(staffName) ? staffName.Substring(0, 1).ToUpper() : "";
        var showProfilePic = !string.IsNullOrEmpty(profilePic);
        var colors = new string[] { "#29abe2", "#f0ad4e", "#8e44ad", "#27ae60", "#d35400" };
        var colorIndex = !string.IsNullOrEmpty(initialLetter) ? ((int)initialLetter[0] % colors.Length) : 0;
        var initialBgColor = colors[colorIndex];
    }
    <nav class="navbar navbar-expand-lg main-navbar fixed-top d-flex justify-content-between align-items-center px-3">
        <!-- Left Section -->
        <div class="d-flex align-items-center">
            <ul class="navbar-nav mr-3">
                <li><a href="#" data-toggle="sidebar" class="nav-link nav-link-lg"><i class="fas fa-bars"></i></a></li>
            </ul>
            <div class="breadcrumb-wrapper d-none d-sm-inline-block ml-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb bg-transparent p-2 m-0">
                        <li class="breadcrumb-item"><a href="#">Home</a></li>
                        <li class="breadcrumb-item active">@ViewBag.Title</li>
                    </ol>
                </nav>
            </div>
        </div>
        <ul class="navbar-nav navbar-right d-flex align-items-center">
            <!-- Calendar Icon -->
            <li class="pt-2 px-2">
                <a href="#" class="nav-link nav-link-lg" title="Calendar">
                    <i class="fas fa-calendar-alt"></i>
                </a>
            </li>
            <!-- Notification Icon -->
            <li class="dropdown dropdown-list-toggle pt-2 px-2">
                <a href="#" data-toggle="dropdown" class="nav-link notification-toggle nav-link-lg beep">
                    <i class="far fa-bell"></i>
                </a>
                <div class="dropdown-menu dropdown-list dropdown-menu-right">
                    <div class="dropdown-header">
                        Notifications
                        <div class="float-right">
                            <a href="#">Mark All As Read</a>
                        </div>
                    </div>
                    <div class="dropdown-list-content dropdown-list-icons">
                        <a href="#" class="dropdown-item dropdown-item-unread">
                            <div class="dropdown-item-icon bg-primary text-white">
                                <i class="fas fa-code"></i>
                            </div>
                            <div class="dropdown-item-desc">
                                Template update is available now!
                                <div class="time text-primary">2 Min Ago</div>
                            </div>
                        </a>
                        <a href="#" class="dropdown-item">
                            <div class="dropdown-item-icon bg-info text-white">
                                <i class="far fa-user"></i>
                            </div>
                            <div class="dropdown-item-desc">
                                <b>You</b> and <b>Dedik Sugiharto</b> are now friends
                                <div class="time">10 Hours Ago</div>
                            </div>
                        </a>
                        <a href="#" class="dropdown-item">
                            <div class="dropdown-item-icon bg-success text-white">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="dropdown-item-desc">
                                <b>Kusnaedi</b> has moved task <b>Fix bug header</b> to <b>Done</b>
                                <div class="time">12 Hours Ago</div>
                            </div>
                        </a>
                        <a href="#" class="dropdown-item">
                            <div class="dropdown-item-icon bg-danger text-white">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="dropdown-item-desc">
                                Low disk space. Let's clean it!
                                <div class="time">17 Hours Ago</div>
                            </div>
                        </a>
                        <a href="#" class="dropdown-item">
                            <div class="dropdown-item-icon bg-info text-white">
                                <i class="fas fa-bell"></i>
                            </div>
                            <div class="dropdown-item-desc">
                                Welcome to Stisla template!
                                <div class="time">Yesterday</div>
                            </div>
                        </a>
                    </div>
                    <div class="dropdown-footer text-center">
                        <a href="#">View All <i class="fas fa-chevron-right"></i></a>
                    </div>
                </div>
            </li>
            <!-- Profile Section -->
            <li class="dropdown d-flex align-items-center px-2">
                <a href="#" data-toggle="dropdown" class="nav-link dropdown-toggle nav-link-lg nav-link-user d-flex align-items-center">
                    <div class="rounded-circle mr-2" style="width: 45px; height: 45px; object-fit: cover; display: flex; align-items: center; justify-content: center; font-size: 18px;
                @if (!showProfilePic) { @Html.Raw("background-color: " + initialBgColor + "; color: white;") }">
                        @if (showProfilePic)
                        {
                            <img alt="image" src="@profilePic" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;" />
                        }
                        else
                        {
                            @initialLetter
                        }
                    </div>
                    <span class="d-none d-sm-inline text-dark font-weight-medium">@staffName</span>
                </a>
                <div class="dropdown-menu dropdown-menu-right">
                    <div class="dropdown-title">Logged in 5 min ago</div>
                    <a href="#" class="dropdown-item has-icon">
                        <i class="far fa-user"></i> Profile
                    </a>
                    <a href="#" class="dropdown-item has-icon">
                        <i class="fas fa-bolt"></i> Policy And Terms
                    </a>
                    <a href="#" class="dropdown-item has-icon text-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </li>
        </ul>
    </nav>
    <div class="main-sidebar sidebar-style-2">
        <aside id="sidebar-wrapper">
            <div class="sidebar-brand">
                <a href="#">Society Management System</a>
            </div>
            @Html.Partial("_Sidebar")
        </aside>
    </div>

    @RenderBody()

    <footer class="main-footer">
        <div class="footer-left">
            Copyright &copy; 2018
            <div class="bullet"></div>
            Design By
            <a href="http://gayasofttech.com/" target="_blank" rel="noopener">Gaya Software Technology</a>
        </div>
        <div class="footer-right"></div>
    </footer>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Clear all active classes from sidebar items
            function clearActiveStates() {
                document.querySelectorAll(".sidebar-menu .nav-link, .sidebar-menu .dropdown").forEach(el => {
                    el.classList.remove("active");
                });
            }

            // Set active link based on current URL (excluding Dashboard, handled by Razor)
            function setActiveLink() {
                const currentPath = window.location.pathname.toLowerCase(); // normalize path
                const links = document.querySelectorAll(".sidebar-menu a.nav-link");

                links.forEach(link => {
                    const linkHref = new URL(link.href).pathname.toLowerCase();

                    // Skip if this is the dashboard link (already handled by Razor)
                    if (linkHref.includes("/dashboard")) return;

                    if (linkHref === currentPath) {
                        clearActiveStates();

                        link.classList.add("active");
                        link.closest('li')?.classList.add("active");

                        const parentDropdown = link.closest(".dropdown");
                        if (parentDropdown && parentDropdown !== link.closest('li')) {
                            parentDropdown.classList.add("active");
                        }
                    }
                });
            }

            // Apply active states on load
            setActiveLink();

            // Update active class on click
            document.querySelectorAll(".sidebar-menu .nav-link").forEach(link => {
                link.addEventListener("click", function () {
                    clearActiveStates();

                    this.classList.add("active");
                    this.closest("li")?.classList.add("active");

                    const parentDropdown = this.closest(".dropdown");
                    if (parentDropdown && parentDropdown !== this.closest('li')) {
                        parentDropdown.classList.add("active");
                    }
                });
            });
        });
    </script>

    <script>
        $(document).ready(function () {
            $('.dropdown-menu .nav-link').on('click', function () {
                // Remove active-submenu from all submenu links
                $('.dropdown-menu .nav-link').removeClass('active-submenu');

                // Add active-submenu only to the clicked link
                $(this).addClass('active-submenu');
            });
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


    @RenderSection("Scripts", required: false)
</body>