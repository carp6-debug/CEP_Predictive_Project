namespace CEP_Predictive_Dashboard.Models
{
    public class AssetStatus
    {
        public int AssetId { get; set; }
        public string AssetTag { get; set; } = string.Empty;
        public string ProjectName { get; set; } = string.Empty;
        public string Borough { get; set; } = string.Empty;
        public double VibrationLevel { get; set; }
        public string StatusCode => VibrationLevel > 3.4 ? "Critical" 
                         : VibrationLevel > 3.01 ? "Warning" 
                         : "Operational";

        // Senior Implementation: Logic-driven UI styling
        public string AlertColor => StatusCode == "Critical" ? "danger" 
                          : StatusCode == "Warning" ? "warning" 
                          : "success";

        // Add this to your AssetStatus Model
        public string CardStyle => StatusCode == "Critical" ? "border-left: 5px solid #dc3545; background-color: #fff5f5;"
                         : StatusCode == "Warning" ? "border-left: 5px solid #ffc107; background-color: #fffdf5;"
                         : "border-left: 5px solid #198754; background-color: #f5fff7;";
    }
}